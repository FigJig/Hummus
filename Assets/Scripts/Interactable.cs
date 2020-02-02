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
	private float m_ResourceValue = 1f;

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
	public float ResourceValue { get { return m_ResourceValue; } }
	public EInteractableType InteractableType { get { return m_InteractableType; } }

	void Start()
	{
		//m_Animator = GetComponent<Animator>();
		m_SpeedId = Animator.StringToHash("Speed");
		m_MeshRenderer = GetComponent<MeshRenderer>();

		//if (m_Animator != null)
		//{
		//	m_Animator.enabled = true;
		//	if (m_InteractableType == EInteractableType.Destructable)
		//	{
		//		m_Animator.Play(0, 0, 1f);
		//	}
		//	else if (m_InteractableType == EInteractableType.Repairable)
		//	{
		//		m_Animator.Play(0, 0, 0f);
		//	}
		//	StartCoroutine(_DisableAnimator());
		//}
	}

	//private IEnumerator _DisableAnimator()
	//{
	//	yield return null;
	//	m_Animator.enabled = false;
	//}

	public void StartDestruct()
	{
		m_InteractableType = EInteractableType.Destructable;
		OnDestruct.Invoke();



		//if (m_Animator != null)
		//{
		//	m_Animator.enabled = true;
		//	SetSpeed(1f);
		//}
	}

	public void StartRepair()
	{
		m_InteractableType = EInteractableType.Repairable;
		OnRepair.Invoke();

		//if (m_Animator != null)
		//{
		//	m_Animator.enabled = true;
		//	SetSpeed(-1f);
		//}
	}

	public void SelectInteract()
	{
		Debug.Log("SelectInteract " + name);
		OnSelect.Invoke();

		m_MeshRenderer?.material?.SetInt("_OutlineSwitch", 1);
	}

	public void DeselectInteract()
	{
		Debug.Log("DeselectInteract " + name);
		OnDeselect.Invoke();

		m_MeshRenderer?.material?.SetInt("_OutlineSwitch", 0);
	}

	//private void SetSpeed(float speed)
	//{
	//	//Cap the time between 0 and 1
	//	if (m_Animator.GetCurrentAnimatorStateInfo(0).normalizedTime > 1f)
	//	{
	//		m_Animator.Play(0, 0, 1f);
	//	}
	//	else if (m_Animator.GetCurrentAnimatorStateInfo(0).normalizedTime < 0f)
	//	{
	//		m_Animator.Play(0, 0, 0f);
	//	}

	//	m_Animator.SetFloat(m_SpeedId, speed);
	//}
}
