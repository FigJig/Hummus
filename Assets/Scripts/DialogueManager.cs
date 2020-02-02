using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DialogueManager : MonoBehaviour
{
	public static DialogueManager Instance;

	[SerializeField]
	private TMPro.TextMeshProUGUI m_DialogueText;
	[SerializeField]
	private GameObject m_DialogueContainer;
	[SerializeField]
	private Image m_CharacterImage;

	public bool IsInDialogue { get; private set; }

	void Awake()
	{
		if (Instance == null)
		{
			Instance = this;
		}
		else if (Instance != this)
		{
			Destroy(gameObject);
		}
	}

	public void ShowDialogue(string text)
	{
		IsInDialogue = true;
		m_DialogueText.text = text;
		m_DialogueContainer.SetActive(true);
	}

	public void HideDialogue()
	{
		IsInDialogue = false;
		m_DialogueContainer.SetActive(false);
	}

	public void SetSprite(Sprite sprite)
	{
		m_CharacterImage.sprite = sprite;
	}
}
