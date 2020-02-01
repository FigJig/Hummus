using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInteract : MonoBehaviour
{
	private enum EInteractType
	{
		Left,
		Right
	}

	[SerializeField]
	private float m_InteractRange;
	[SerializeField]
	private LayerMask m_InteractMask;
	[SerializeField]
	private LayerMask m_BlockerMask;

	private LayerMask m_AllMask;

	void Start()
	{
		m_AllMask = m_InteractMask | m_BlockerMask;
	}

	void Update()
	{
		ProcessInput();
	}

	private void ProcessInput()
	{
		//Left
		if (Input.GetMouseButtonDown(0))
		{
			GetComponent<Rigidbody2D>().AddForce(new Vector2(0f, 100f));

			Interactable interactable = GetHitInteractable();
			if (interactable != null)
			{
				interactable.OnLeftDown.Invoke();
			}
		}

		if (Input.GetMouseButton(0))
		{
			Interactable interactable = GetHitInteractable();
			if (interactable != null)
			{
				interactable.OnLeftHeld.Invoke();
			}
		}

		if (Input.GetMouseButtonUp(0))
		{
			Interactable interactable = GetHitInteractable();
			if (interactable != null)
			{
				interactable.OnLeftUp.Invoke();
			}
		}

		//Right
		if (Input.GetMouseButtonDown(1))
		{
			Interactable interactable = GetHitInteractable();
			if (interactable != null)
			{
				interactable.OnRightDown.Invoke();
			}
		}

		if (Input.GetMouseButton(1))
		{
			Interactable interactable = GetHitInteractable();
			if (interactable != null)
			{
				interactable.OnRightHeld.Invoke();
			}
		}

		if (Input.GetMouseButtonUp(1))
		{
			Interactable interactable = GetHitInteractable();
			if (interactable != null)
			{
				interactable.OnRightUp.Invoke();
			}
		}
	}

	private Interactable GetHitInteractable()
	{
		RaycastHit2D hit = Physics2D.Raycast(transform.position, transform.right, m_InteractRange, m_AllMask);
		if (hit.collider != null)
		{
			if (hit.collider.gameObject.layer == (hit.collider.gameObject.layer | (1 << m_InteractMask)))
			{
				Debug.Log("Interact");
				return hit.collider.gameObject.GetComponent<Interactable>();
			}
			else
			{
				Debug.Log("Don't Interact");
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
