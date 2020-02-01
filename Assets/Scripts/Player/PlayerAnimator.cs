using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimator : MonoBehaviour
{
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
			case PlayerMovement.PlayerState.JumpingLeft:
				break;
		}
	}
}
