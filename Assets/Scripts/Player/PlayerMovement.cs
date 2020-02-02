using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class PlayerMovement : MonoBehaviour
{
	public enum PlayerState
	{
		IdleLeft,
		IdleRight,
		MovingLeft,
		MovingRight,
		JumpingLeft,
		JumpingRight,
		RepairLeft,
		RepairRight,
		DestructLeft,
		DestructRight
	}
	public float moveSpeed;
	public float acceleration;
	public float jumpHeight;
	public AudioClip jumpClip;
	public LayerMask layerMaskForGrounded;
	public LayerMask layerMaskForPlatforms;
	[Header("Raycast Lengths")]
	public float raycastUpLength;
	public float raycastDownLength;
	[Header("Raycast Positions")]
	public float raycastUpPosOffset;
	public float raycastDownPosOffset;
	public PlayerState playerState;
	public int LookDirection
	{
		get
		{
			switch (playerState)
			{
				case PlayerState.IdleLeft:
				case PlayerState.JumpingLeft:
				case PlayerState.MovingLeft:
					{
						return -1;
					}
			}
			return 1;
		}
	}
	private AudioSource _audioSource;
	private float _isGroundedRayLength = 0.05f;
	private float _xMovement;
	private float _yVelocity;
	private bool _isJumping;
	private float _movementSpeed; private Rigidbody2D _rb;
	private Vector2 _velocity;
	public Collider2D collider;

	void Start()
	{
		_audioSource = GetComponent<AudioSource>();
		_rb = GetComponent<Rigidbody2D>();
		_isJumping = false;
	}
	void FixedUpdate()
	{
		if (!UIManager.MenuIsActive && !DialogueManager.Instance.IsInDialogue)
		{
			CalculateMovement();
		}
	}
	void CalculateMovement()
	{
		float xInput = Input.GetAxisRaw("Horizontal"); if (JumpingAbovePlatform)
		{
			Debug.Log("jumping above platform");
		}
		Vector2 movementHoritzontal = Vector2.right * xInput;
		_velocity = Vector2.zero; if (xInput != 0)
		{
			_movementSpeed = Mathf.MoveTowards(_movementSpeed, moveSpeed, acceleration);
			_velocity = movementHoritzontal.normalized * _movementSpeed;
		}
		else if (xInput == 0)
		{
			_movementSpeed = Mathf.MoveTowards(_movementSpeed, 0f, acceleration);
			_velocity = movementHoritzontal.normalized * _movementSpeed;
		}
		if (IsGrounded)
		{
			if (!JumpingAbovePlatform)
			{
				_yVelocity = 0;
			}
			if (Input.GetButtonDown("Jump"))
			{
				_audioSource.PlayOneShot(jumpClip);
				_yVelocity = jumpHeight;
			}
		}
		else
		{
			_yVelocity -= 9.8f * Time.fixedDeltaTime;
		}
		DetermineState(xInput, IsGrounded);
		_velocity.y = _yVelocity;
		_rb.MovePosition(_rb.position + _velocity * Time.fixedDeltaTime);
	}
	void DetermineState(float xInput, bool isGrounded)
	{
		if (!isGrounded)
		{
			if (xInput > 0.1f || playerState == PlayerState.MovingRight || playerState == PlayerState.IdleRight)
			{
				playerState = PlayerState.JumpingRight;
			}
			if (xInput < -0.1f || playerState == PlayerState.MovingLeft || playerState == PlayerState.IdleLeft)
			{
				playerState = PlayerState.JumpingLeft;
			}
			return;
		}
		else
		{
			if (xInput > 0.1f)
			{
				playerState = PlayerState.MovingRight;
			}
			if (xInput < -0.1f)
			{
				playerState = PlayerState.MovingLeft;
			}
			if (xInput == 0 && playerState == PlayerState.MovingRight || playerState == PlayerState.JumpingRight)
			{
				playerState = PlayerState.IdleRight;
			}
			if (xInput == 0 && playerState == PlayerState.MovingLeft || playerState == PlayerState.JumpingLeft)
			{
				playerState = PlayerState.IdleLeft;
			}
		}
	}
	public bool JumpingAbovePlatform
	{
		get
		{
			Vector3 midPosition = transform.position;
			midPosition.y = collider.bounds.max.y - raycastUpPosOffset; Vector3 rightPosition = transform.position;
			rightPosition.y = collider.bounds.max.y - raycastUpPosOffset;
			rightPosition.x = collider.bounds.max.x - collider.bounds.size.x; Vector3 leftPosition = transform.position;
			leftPosition.y = collider.bounds.max.y - raycastUpPosOffset;
			leftPosition.x = collider.bounds.max.x; float length = _isGroundedRayLength + raycastUpLength; Debug.DrawRay(midPosition, Vector2.up * length, Color.green);
			Debug.DrawRay(rightPosition, Vector2.up * length, Color.green);
			Debug.DrawRay(leftPosition, Vector2.up * length, Color.green); if (Physics2D.Raycast(midPosition, Vector2.up, length, layerMaskForPlatforms.value))
			{
				return true;
			}
			if (Physics2D.Raycast(rightPosition, Vector2.up, length, layerMaskForPlatforms.value))
			{
				return true;
			}
			if (Physics2D.Raycast(leftPosition, Vector2.up, length, layerMaskForPlatforms.value))
			{
				return true;
			}
			return false;
		}
	}
	public bool IsGrounded
	{
		get
		{
			Vector3 midPosition = transform.position;
			midPosition.y = collider.bounds.min.y + raycastDownPosOffset; Vector3 rightPosition = transform.position;
			rightPosition.y = collider.bounds.min.y + raycastDownPosOffset;
			rightPosition.x = collider.bounds.min.x + collider.bounds.size.x; Vector3 leftPosition = transform.position;
			leftPosition.y = collider.bounds.min.y + raycastDownPosOffset;
			leftPosition.x = collider.bounds.min.x; float length = _isGroundedRayLength + raycastDownLength; Debug.DrawRay(midPosition, Vector2.down * length, Color.red);
			Debug.DrawRay(rightPosition, Vector2.down * length, Color.red);
			Debug.DrawRay(leftPosition, Vector2.down * length, Color.red); if (Physics2D.Raycast(midPosition, Vector2.down, length, layerMaskForGrounded.value))
			{
				return true;
			}
			if (Physics2D.Raycast(rightPosition, Vector2.down, length, layerMaskForGrounded.value))
			{
				return true;
			}
			if (Physics2D.Raycast(leftPosition, Vector2.down, length, layerMaskForGrounded.value))
			{
				return true;
			}
			return false;
		}
	}
	public void OnDrawGizmos()
	{
		Vector3 midPositionDown = transform.position;
		midPositionDown.y = collider.bounds.min.y + raycastDownPosOffset; Vector3 rightPositionDown = transform.position;
		rightPositionDown.y = collider.bounds.min.y + raycastDownPosOffset;
		rightPositionDown.x = collider.bounds.min.x + collider.bounds.size.x; Vector3 leftPositionDown = transform.position;
		leftPositionDown.y = collider.bounds.min.y + raycastDownPosOffset;
		leftPositionDown.x = collider.bounds.min.x; float lengthDown = _isGroundedRayLength + raycastDownLength; Debug.DrawRay(midPositionDown, Vector2.down * lengthDown, Color.red);
		Debug.DrawRay(rightPositionDown, Vector2.down * lengthDown, Color.red);
		Debug.DrawRay(leftPositionDown, Vector2.down * lengthDown, Color.red); Vector3 midPositionUp = transform.position;
		midPositionUp.y = collider.bounds.max.y - raycastUpPosOffset; Vector3 rightPositionUp = transform.position;
		rightPositionUp.y = collider.bounds.max.y - raycastUpPosOffset;
		rightPositionUp.x = collider.bounds.max.x - collider.bounds.size.x; Vector3 leftPositionUp = transform.position;
		leftPositionUp.y = collider.bounds.max.y - raycastUpPosOffset;
		leftPositionUp.x = collider.bounds.max.x; float lengthUp = _isGroundedRayLength + raycastUpLength; Debug.DrawRay(midPositionUp, Vector2.up * lengthUp, Color.green);
		Debug.DrawRay(rightPositionUp, Vector2.up * lengthUp, Color.green);
		Debug.DrawRay(leftPositionUp, Vector2.up * lengthUp, Color.green);
	}
}