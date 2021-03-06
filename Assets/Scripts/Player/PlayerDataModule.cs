﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDataModule : MonoBehaviour
{
	public static PlayerDataModule Inst;

	public PlayerMovement playerMovement;
	public PlayerAnimator playerAnimator;

    void Awake()
    {
		if (Inst == null)
		{
			Inst = this;
		}
		else if (Inst != this)
		{
			Destroy(gameObject);
		}
    }
}
