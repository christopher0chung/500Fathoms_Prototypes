using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayLogic : MonoBehaviour {
    // This class is responsible for controlling all aspects of the display quads
    // A state machine will control the operation and transition between single and split screen
    // When split, the quads will be scaled and repositioned to match the relative position of the players

    [Header("References")]
    public GameObject q1;
    public GameObject q2;
    [Header("Test Value")]
    public float testAngle;
    [Header("Tuning Values")]
    public float transitionNormTime = .3f;

    #region Internal
    Material _q1Mat;
    Material _q2Mat;
    float falloff;
    float noise;
    #endregion

    #region StoredValues
    float falloff_Single = .5f;
    float falloff_Split = 0f;
    float noise_Single = 1f;
    float noise_Split = .125f;
    Vector2 offset_Left = new Vector2(-.0625f, 0);
    Vector2 offset_Right = new Vector2(.5f, 0);
    #endregion

    #region Calculation Variables
    private float _dot;
    private float _invDot;
    private float _absDot;
    private Vector3 _pos;
    private Vector3 _euler;
    #endregion

    private bool toggle;

    private float _relativeAngle;
    public float relativeAngle
    {
        get
        {
            return _relativeAngle;
        }
        set
        {
            if (value != _relativeAngle)
            {
                _relativeAngle = value;

                _euler.z = _relativeAngle;

                // When side by side, dot = 0
                _dot = (Vector3.Dot(Vector3.right, Quaternion.Euler(_euler) * Vector3.right));
                _invDot = (Vector3.Dot(Vector3.up, Quaternion.Euler(_euler) * Vector3.right));
                _absDot = Mathf.Abs(_dot);
            }
        }
    }

    private FSM<DisplayLogic> _fsm;

    void Awake()
    {
        _q1Mat = q1.GetComponent<MeshRenderer>().material;
        _q2Mat = q2.GetComponent<MeshRenderer>().material;
        _fsm = new FSM<DisplayLogic>(this);
        _fsm.TransitionTo<Single>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            toggle = !toggle;

            if (toggle)
                _fsm.TransitionTo<SingleToSplit>();
            else 
                _fsm.TransitionTo<SplitToSingle>();
        }

        if (Input.GetKey(KeyCode.A))
            testAngle++;
        if (Input.GetKey(KeyCode.D))
            testAngle--;

        _fsm.Update();
        _q1Mat.SetFloat("_Falloff", falloff);
        _q2Mat.SetFloat("_Falloff", falloff);
        _q1Mat.SetFloat("_NoiseCutoff", noise);
        _q2Mat.SetFloat("_NoiseCutoff", noise);

        _MoveQuads();
    }

    private void _MoveQuads()
    {
        _pos.x = -4.5f * _dot;
        _pos.y = 2.2f * _invDot;
        _pos.z = 1;

        q1.transform.position = _pos;
        _pos.z = -1; // To keep q2 in front of camera with a (+) z value
        q2.transform.position = -_pos;

        q1.transform.localScale = q2.transform.localScale = Vector3.one * ((6) + _absDot * _absDot * 3f);
    }

    #region FSM States
    protected class State_Base : FSM<DisplayLogic>.State
    {

    }

    protected class Single : State_Base
    {
        public override void OnEnter()
        {
            Context.falloff = Context.falloff_Single;
            Context.noise = Context.noise_Single;
        }
    }

    protected class SingleToSplit : State_Base
    {
        float timer;

        public override void OnEnter()
        {
            timer = 0;
        }
        public override void Update()
        {
            timer += Time.deltaTime / Context.transitionNormTime;
            Context.falloff = Mathf.Lerp(Context.falloff_Single, Context.falloff_Split, timer);
            Context.noise = Mathf.Lerp(Context.noise_Single, Context.noise_Split, timer);

            if (timer >= 1)
                TransitionTo<Split>();
        }
    }

    protected class Split : State_Base
    {
        public override void OnEnter()
        {
            Context.falloff = Context.falloff_Split;
            Context.noise = Context.noise_Split;
        }

        public override void Update()
        {
            Context.relativeAngle = Mathf.Lerp(Context.relativeAngle, Context.testAngle, .05f);
        }
    }

    protected class SplitToSingle : State_Base
    {
        float timer;
        float angleSnapShot;
        Vector2 offsetSnapShot1;
        Vector2 offsetSnapShot2;

        public override void OnEnter()
        {
            timer = 0;

            Context.relativeAngle = (Context.relativeAngle + 360) % 360;

            angleSnapShot = Context.relativeAngle;
            offsetSnapShot1 = Context._q1Mat.GetTextureOffset("_Albedo");
            offsetSnapShot2 = Context._q2Mat.GetTextureOffset("_Albedo");

        }
        public override void Update()
        {
            timer += Time.deltaTime / (2 * Context.transitionNormTime);

            Context.falloff = Mathf.Lerp(Context.falloff_Split, Context.falloff_Single, timer - Context.transitionNormTime);
            Context.noise = Mathf.Lerp(Context.noise_Split, Context.noise_Single, timer - Context.transitionNormTime);

            if (Context.relativeAngle <= 90)
            {
                Context.relativeAngle = Mathf.Lerp(angleSnapShot, 0, timer * 2);

                Context._q1Mat.SetTextureOffset("_Albedo", Vector2.Lerp(offsetSnapShot1, Context.offset_Left, timer * 3));
                Context._q2Mat.SetTextureOffset("_Albedo", Vector2.Lerp(offsetSnapShot2, Context.offset_Right, timer * 3));
            }
            else if (Context.relativeAngle > 90 && Context.relativeAngle <= 270)
            {
                Context.relativeAngle = Mathf.Lerp(angleSnapShot, 180, timer * 2);

                Context._q1Mat.SetTextureOffset("_Albedo", Vector2.Lerp(offsetSnapShot1, Context.offset_Right, timer * 3));
                Context._q2Mat.SetTextureOffset("_Albedo", Vector2.Lerp(offsetSnapShot2, Context.offset_Left, timer * 3));
            }
            else
            {
                Context.relativeAngle = Mathf.Lerp(angleSnapShot, 360, timer * 2);

                Context._q1Mat.SetTextureOffset("_Albedo", Vector2.Lerp(offsetSnapShot1, Context.offset_Left, timer * 3));
                Context._q2Mat.SetTextureOffset("_Albedo", Vector2.Lerp(offsetSnapShot2, Context.offset_Right, timer * 3));
            }
            

            if (timer >= 1)
                TransitionTo<Single>();
        }

        public override void OnExit()
        {
            Context.testAngle = Context.relativeAngle;
        }
    }
    #endregion
}
