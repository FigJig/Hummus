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
		JumpingRight
	}

	public float moveSpeed;
	public float acceleration;
	public float jumpHeight;
	public LayerMask layerMaskForGrounded;

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

	private float _isGroundedRayLength = 0.05f;
	private float _xMovement;
	private float _yVelocity;
	private bool _isJumping;
	private float _movementSpeed;

	private Rigidbody2D _rb;
	private Vector2 _velocity;
	private Collider2D _collider;

	void Start()
	{
		_rb = GetComponent<Rigidbody2D>();
		_collider = GetComponent<Collider2D>();
	}

	void FixedUpdate()
	{
		CalculateMovement();
	}

	void CalculateMovement()
	{
		float xInput = Input.GetAxisRaw("Horizontal");

		Vector2 movementHoritzontal = Vector2.right * xInput;
		_velocity = Vector2.zero;

		if (xInput != 0)
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
			_yVelocity = 0f;

			if (Input.GetButtonDown("Jump"))
			{
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

	public bool IsGrounded
	{
		get
		{
			Vector3 midPosition = transform.position;
			midPosition.y = _collider.bounds.min.y + 0.1f;

			Vector3 rightPosition = transform.position;
			rightPosition.y = _collider.bounds.min.y + 0.1f;
			rightPosition.x = _collider.bounds.min.x + _collider.bounds.size.x;

			Vector3 leftPosition = transform.position;
			leftPosition.y = _collider.bounds.min.y + 0.1f;
			leftPosition.x = _collider.bounds.min.x;

			float length = _isGroundedRayLength + 0.1f;

			Debug.DrawRay(midPosition, Vector2.down * length, Color.red);
			Debug.DrawRay(rightPosition, Vector2.down * length, Color.red);
			Debug.DrawRay(leftPosition, Vector2.down * length, Color.red);

			if (Physics2D.Raycast(midPosition, Vector2.down, length, layerMaskForGrounded.value))
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
}
