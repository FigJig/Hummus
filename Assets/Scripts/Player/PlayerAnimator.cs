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
				break;
			case PlayerMovement.PlayerState.IdleRight:
				break;
			case PlayerMovement.PlayerState.MovingLeft:
				break;
			case PlayerMovement.PlayerState.MovingRight:
				break;
			case PlayerMovement.PlayerState.JumpingLeft:
				break;
			case PlayerMovement.PlayerState.JumpingRight:
				break;
		}
	}
}
