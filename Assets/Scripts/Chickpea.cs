using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chickpea : MonoBehaviour
{
	public int blockerToRemove;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			GameManager.Inst.RemoveBlocker(blockerToRemove);
			Destroy(gameObject);
		}
	}
}
