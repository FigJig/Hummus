using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class UIManager : MonoBehaviour
{
	public static UIManager Inst;

	public static bool MenuIsActive;

	public GameObject inGameMenu;
	public TextMeshProUGUI chickpeaText;
	public TextMeshProUGUI plantText;
	public TextMeshProUGUI mineralText;
	public TextMeshProUGUI summuhText;

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

		MenuIsActive = false;
		inGameMenu.SetActive(false);
	}

	private void Update()
	{
		if (Input.GetButtonDown("OpenMenu"))
		{
			inGameMenu.SetActive(!inGameMenu.activeInHierarchy);
			MenuIsActive = inGameMenu.activeInHierarchy;
			return;
		}

		if (inGameMenu.activeInHierarchy)
		{
			if (Input.GetButtonDown("Jump"))
			{
				inGameMenu.SetActive(!inGameMenu.activeInHierarchy);
				MenuIsActive = false;
			}

			if (Input.GetButtonDown("Cancel"))
			{
				Debug.Log("Pressed cancel");
				SceneManager.LoadScene("SC_MainMenu");
			}
		}
	}

	public void UpdateChickpeaAmount(int amount)
	{
		chickpeaText.text = amount.ToString();
	}

	public void UpdatePlantAmount(int amount)
	{
		plantText.text = amount.ToString();
	}

	public void UpdateMineralAmount(int amount)
	{
		mineralText.text = amount.ToString();
	}

	public void UpdateSummuhAmount(int amount)
	{
		summuhText.text = amount.ToString();
	}
}
