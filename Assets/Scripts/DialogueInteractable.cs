using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Interactable))]
public class DialogueInteractable : MonoBehaviour
{
	[SerializeField]
	private string[] m_DialogueStrings;
	[SerializeField]
	private Sprite m_CharacterSprite;
	[SerializeField]
	private bool m_IsBoss = false;

	private bool m_IsShowing = false;
	private int m_DialogueIndex = 0;

	private Action OnFinishDialogue;

	public void NextDialogue()
	{
		Debug.Log("Next Dialogue");

		m_DialogueIndex++;
		if (m_DialogueIndex >= m_DialogueStrings.Length)
		{
			EndDialogue();
		}
		else
		{
			DialogueManager.Instance.ShowDialogue(m_DialogueStrings[m_DialogueIndex]);
		}
	}

	public void StartDialogue(Action onFinish)
	{
		Debug.Log("Start Dialogue");
		m_IsShowing = true;
		m_DialogueIndex = 0;
		DialogueManager.Instance.SetSprite(m_CharacterSprite);
		DialogueManager.Instance.ShowDialogue(m_DialogueStrings[m_DialogueIndex]);
		OnFinishDialogue = onFinish;
	}

	private void EndDialogue()
	{
		Debug.Log("End Dialogue");
		if (m_IsBoss)
		{
			GetComponent<Credits>().StartCredits();
		}
		m_IsShowing = false;
		DialogueManager.Instance.HideDialogue();
		OnFinishDialogue();
		OnFinishDialogue = null;
	}
}
