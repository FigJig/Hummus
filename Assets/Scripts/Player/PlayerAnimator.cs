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
	public string destructLeftAnim;
	public string destructRightAnim;
	public string repairLeftAnim;
	public string repairRightAnim;

	private Animator _animator;
	private PlayerDataModule _player;
	private AudioSource _audioSource;

	private void Start()
	{
		_animator = GetComponent<Animator>();
		_player = PlayerDataModule.Inst;
		_audioSource = GetComponent<AudioSource>();
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
			case PlayerMovement.PlayerState.RepairLeft:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(repairLeftAnim))
				{
					break;
				}
				_animator.Play(repairLeftAnim);
				break;
			case PlayerMovement.PlayerState.RepairRight:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(repairRightAnim))
				{
					break;
				}
				_animator.Play(repairRightAnim);
				break;
			case PlayerMovement.PlayerState.DestructLeft:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(destructLeftAnim))
				{
					break;
				}
				_animator.Play(destructLeftAnim);
				break;
			case PlayerMovement.PlayerState.DestructRight:
				if (_animator.GetCurrentAnimatorStateInfo(0).IsName(destructRightAnim))
				{
					break;
				}
				_animator.Play(destructRightAnim);
				break;
		}
	}

	public void PlaySound (AudioClip clip)
	{
		_audioSource.PlayOneShot(clip);
	}
}
