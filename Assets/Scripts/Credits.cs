using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Credits : MonoBehaviour
{
	public static bool CreditsPlaying = false;

	public GameObject creditsCanvas;
	private Animator _creditsAnimator;

	private void Start()
	{
		_creditsAnimator = creditsCanvas.GetComponent<Animator>();
	}

	public void StartCredits()
	{
		StartCoroutine(CreditsRoutine());
	}

	IEnumerator CreditsRoutine()
	{
		CreditsPlaying = true;
		creditsCanvas.SetActive(true);
		_creditsAnimator.Play("AN_Credits");

		yield return new WaitForSeconds(25f);

		SceneManager.LoadScene("SC_MainMenu");
	}
}
