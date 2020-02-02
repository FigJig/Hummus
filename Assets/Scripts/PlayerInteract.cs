using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum EInteractType
{
	None,
	Destruct,       //Left
	Repair,          //Right
}

[RequireComponent(typeof(PlayerResources))]
public class PlayerInteract : MonoBehaviour
{
	[SerializeField]
	private float m_InteractRange;
	[SerializeField]
	private LayerMask m_InteractMask;
	[SerializeField]
	private LayerMask m_BlockerMask;

	private LayerMask m_AllMask;
	private PlayerResources m_PlayerResources;

	[SerializeField]
	private EInteractType m_CurrentInteractType = EInteractType.None;
	[SerializeField]
	private Interactable m_CurrentInteractable;
	private Interactable m_PrevInteractable;

	private DialogueInteractable m_CurrentDialogue;

	void Start()
	{
		m_PlayerResources = GetComponent<PlayerResources>();
		m_AllMask = m_InteractMask | m_BlockerMask;
	}

	void Update()
	{
		m_CurrentInteractable = GetHitInteractable();

		if (m_CurrentInteractable != m_PrevInteractable)
		{
			m_PrevInteractable?.DeselectInteract();
			m_CurrentInteractable?.SelectInteract();
			m_PrevInteractable = m_CurrentInteractable;
		}

		ProcessInput();
	}

	private void EndDialogue()
	{
		m_CurrentDialogue = null;
	}

	private void ProcessInput()
	{
		//Left
		if (Input.GetMouseButtonDown(0))
		{
			if (DialogueManager.Instance.IsInDialogue)
			{
				m_CurrentDialogue.NextDialogue();
			}
			else if (m_CurrentInteractable != null)
			{
				if (m_CurrentInteractable.InteractableType == EInteractableType.Dialogue)
				{
					m_CurrentDialogue = m_CurrentInteractable.GetComponent<DialogueInteractable>();
					if (m_CurrentDialogue == null)
					{
						Debug.LogError("No DialogueInteractable component found");
					}
					else
					{
						m_CurrentDialogue.StartDialogue(EndDialogue);
					}
				}
				else
				{
					m_CurrentInteractType = EInteractType.Destruct;
					if (m_CurrentInteractable.InteractableType == EInteractableType.Destructable)
					{
						m_PlayerResources.AddResource(m_CurrentInteractable.ResourceType, m_CurrentInteractable.ResourceValue);
						m_CurrentInteractable.StartDestruct();
					}
				}
			}
		}

		//Right
		if (Input.GetMouseButtonDown(1))
		{
			m_CurrentInteractType = EInteractType.Repair;

			if (m_CurrentInteractable != null && m_CurrentInteractable.InteractableType == EInteractableType.Repairable && m_PlayerResources.resources[(int)m_CurrentInteractable.ResourceType].Count > 0)
			{
				m_PlayerResources.UseResource(m_CurrentInteractable.ResourceType, m_CurrentInteractable.ResourceValue);
				m_CurrentInteractable.StartRepair();
			}
		}
	}

	private Interactable GetHitInteractable()
	{
		RaycastHit2D hit = Physics2D.Raycast(transform.position, new Vector2(PlayerDataModule.Inst.playerMovement.LookDirection, 0), m_InteractRange, m_AllMask);
		if (hit.collider != null)
		{
			//Debug.Log("Hit " + hit.collider.name);
			int temp = (hit.collider.gameObject.layer | (1 << m_InteractMask));
			if (hit.collider.gameObject.layer == temp)
			{
				return hit.collider.gameObject.GetComponent<Interactable>();
			}
		}

		return null;
	}
}
