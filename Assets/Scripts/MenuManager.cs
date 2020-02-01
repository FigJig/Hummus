using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuManager : MonoBehaviour
{
	public string[] scenesToLoad;

   public void QuitGame()
	{
		Application.Quit();
	}

	public void LoadScenes()
	{
		SceneManager.LoadScene(scenesToLoad[0], LoadSceneMode.Single);

		for (int i = 1; i < scenesToLoad.Length; i++)
		{
			SceneManager.LoadScene(scenesToLoad[i], LoadSceneMode.Additive);
		}
	}
}
