using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum EResourceType
{
	Wood,
	Stone
}

public class PlayerResources : MonoBehaviour
{
	[System.Serializable]
	public class Resource
	{
		public string name;
		public EResourceType resourceType;
		public int max;

		[SerializeField]
		private float m_Count;
		public float Count
		{
			get
			{
				return m_Count;
			}
			set
			{
				if (value > max)
				{
					m_Count = max;
				}
				else if (value < 0)
				{
					Debug.LogError("Tried to reduce count below 0");
					m_Count = 0;
				}
				else
				{
					m_Count = value;
				}
			}
		}
	}

	[SerializeField]
	private Resource[] m_Resources;

	void Start()
	{

	}

	void Update()
	{
		
	}

	public void AddResource(EResourceType resourceType, float amount)
	{
		m_Resources[(int)resourceType].Count += amount;
	}

	public void UseResource(EResourceType resourceType, float amount)
	{
		m_Resources[(int)resourceType].Count -= amount;
	}
}
