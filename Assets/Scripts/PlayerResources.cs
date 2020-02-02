﻿using System.Collections;
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
		public TMPro.TextMeshProUGUI countText;
		public int max;

		[SerializeField]
		private int m_Count;
		public int Count
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
				countText.text = ((int)(m_Count + 0.99f)).ToString();
			}
		}
	}
	
	public Resource[] resources;

	void Start()
	{
		for (int i = 0; i < resources.Length; i++)
		{
			resources[i].countText.text = (resources[i].Count).ToString();
		}
	}

	public void AddResource(EResourceType resourceType, int amount)
	{
		resources[(int)resourceType].Count += amount;
	}

	public void UseResource(EResourceType resourceType, int amount)
	{
		resources[(int)resourceType].Count -= amount;
	}

	public float GetResourceCount(EResourceType resourceType)
	{
		return resources[(int)resourceType].Count;
	}
}
