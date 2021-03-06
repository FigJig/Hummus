﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
	public static GameManager Inst;

	public GameObject[] blockers;

	//DAD799
	//CE81EC
	public Color repairColor;
	public Color destructColor;

	private void Start()
	{
		if (Inst == null)
		{
			Inst = this;
		}
		else if (Inst != this)
		{
			Destroy(gameObject);
		}

		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
	}

	public void RemoveBlocker(int index)
	{
		blockers[index].SetActive(false);
	}
}
