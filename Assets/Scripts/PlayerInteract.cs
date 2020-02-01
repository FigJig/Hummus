using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum EInteractType
{
	None,
	Destruct,       //Left
	Repair          //Right
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

	void Start()
	{
		m_PlayerResources = GetComponent<PlayerResources>();
		m_AllMask = m_InteractMask | m_BlockerMask;
	}

	void Update()
	{
		m_CurrentInteractable = GetHitInteractable();

		ProcessInput();
	}

	private void ProcessInput()
	{
		//Left
		if (Input.GetMouseButtonDown(0))
		{
			m_CurrentInteractType = EInteractType.Destruct;
			if (m_CurrentInteractable != null && m_CurrentInteractable.InteractState == EInteractType.Repair)
			{
				m_PlayerResources.AddResource(m_CurrentInteractable.ResourceType, m_CurrentInteractable.ResourceValue);
				m_CurrentInteractable.StartDestruct();
			}
		}

		//Right
		if (Input.GetMouseButtonDown(1))
		{
			m_CurrentInteractType = EInteractType.Repair;

			if (m_CurrentInteractable != null && m_CurrentInteractable.InteractState == EInteractType.Destruct)
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
			int temp = (hit.collider.gameObject.layer | (1 << m_InteractMask));
			if (hit.collider.gameObject.layer == temp)
			{
				return hit.collider.gameObject.GetComponent<Interactable>();
			}
		}

		return null;
	}

	void OnDrawGizmos()
	{
		Gizmos.color = Color.blue;
		Vector3 lineEnd = transform.position + new Vector3(m_InteractRange, 0f, 0f);
		Gizmos.DrawLine(transform.position, lineEnd);
	}
}
