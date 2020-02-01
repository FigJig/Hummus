using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimator : MonoBehaviour
{
	public string idleLeftAnim;
	public string idleRightAnim;
	public string movingLeftAnim;
	public string movingRightAnim;
	public string jumpingLeftAnim;
	public string jumpingRightAnim;

	private Animator _animator;
	private PlayerDataModule _player;

	private void Start()
	{
		_animator = GetComponent<Animator>();
		_player = PlayerDataModule.Inst;
	}

	private void Update()
	{
		switch(_player.playerMovement.playerState)
		{
			case PlayerMovement.PlayerState.IdleLeft:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(idleLeftAnim))
				{
					break;
				}
				_animator.Play(idleLeftAnim);
				break;
			case PlayerMovement.PlayerState.IdleRight:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(idleRightAnim))
				{
					break;
				}
				_animator.Play(idleRightAnim);
				break;
			case PlayerMovement.PlayerState.MovingLeft:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(movingLeftAnim))
				{
					break;
				}
				_animator.Play(movingLeftAnim);
				break;
			case PlayerMovement.PlayerState.MovingRight:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(movingRightAnim))
				{
					break;
				}
				_animator.Play(movingRightAnim);
				break;
			case PlayerMovement.PlayerState.JumpingLeft:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(jumpingLeftAnim))
				{
					break;
				}
				_animator.Play(jumpingLeftAnim);
				break;
			case PlayerMovement.PlayerState.JumpingRight:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(jumpingRightAnim))
				{
					break;
				}
				_animator.Play(jumpingRightAnim);
				break;
		}
	}
}
