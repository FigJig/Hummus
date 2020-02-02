using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public enum EInteractableType
{
	Repairable,
	Destructable,
	Dialogue
}

public class Interactable : MonoBehaviour
{
	[SerializeField]
	private EResourceType m_ResourceType;
	[SerializeField]
	private int m_ResourceValue = 1;

	[SerializeField]
	private EInteractableType m_InteractableType = EInteractableType.Repairable;

	[SerializeField]
	private UnityEvent OnDestruct;
	[SerializeField]
	private UnityEvent OnRepair;
	[SerializeField]
	private UnityEvent OnSelect;
	[SerializeField]
	private UnityEvent OnDeselect;

	//private Animator m_Animator;
	private int m_DestructId;
	private int m_SpeedId;
	private float m_NormalizedAnimTime;
	private DialogueInteractable m_DialogueInteractable;

	private MeshRenderer m_MeshRenderer;

	public EResourceType ResourceType { get { return m_ResourceType; } }
	public int ResourceValue { get { return m_ResourceValue; } }
	public EInteractableType InteractableType { get { return m_InteractableType; } }


	void Start()
	{
		//m_Animator = GetComponent<Animator>();
		m_SpeedId = Animator.StringToHash("Speed");
		m_MeshRenderer = GetComponent<MeshRenderer>();
	}

	public void StartDestruct()
	{
		m_InteractableType = EInteractableType.Destructable;
		OnDestruct.Invoke();
	}

	public void StartRepair()
	{
		m_InteractableType = EInteractableType.Repairable;
		OnRepair.Invoke();
	}

	public void SelectInteract()
	{
		Debug.Log("SelectInteract " + name);
		OnSelect.Invoke();

		if (m_MeshRenderer != null)
		{
			m_MeshRenderer?.material?.SetInt("_OutlineSwitch", 1);
		}

		if (InteractableType == EInteractableType.Destructable)
		{
			m_MeshRenderer?.material?.SetColor("_OutlineColor", GameManager.Inst.destructColor);
		}
		else if (InteractableType == EInteractableType.Repairable)
		{
			m_MeshRenderer?.material?.SetColor("_OutlineColor", GameManager.Inst.repairColor);
		}
	}

	public void DeselectInteract()
	{
		Debug.Log("DeselectInteract " + name);
		OnDeselect.Invoke();

		if (m_MeshRenderer != null)
		{
			m_MeshRenderer?.material?.SetInt("_OutlineSwitch", 0);
		}
	}
}
