using UnityEngine;
using System.Collections.Generic;

[CreateAssetMenu(fileName = "NewPrefabList", menuName = "Create Prefab List", order = 1)]
public class PrefabList : ScriptableObject
{
	public List<GameObject> ListOfPrefabs = new List<GameObject>();
}
