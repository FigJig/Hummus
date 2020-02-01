using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathZone : MonoBehaviour
{
	public CheckPoint checkPoint;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			StartCoroutine(DeathRoutine());	
		}
	}

	IEnumerator DeathRoutine()
	{
		PlayerDataModule.Inst.transform.position = checkPoint.transform.position;

		yield return null;
	}
}
