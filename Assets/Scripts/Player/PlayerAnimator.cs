using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimator : MonoBehaviour
{
	private Animator _animator;
	private PlayerDataModule _player;

	private void Start()
	{
		_animator = GetComponent<Animator>();
		_player = PlayerDataModule.Inst;
	}

	private void Update()
	{
		
	}
}
