using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using Unity.EditorCoroutines.Editor;

public enum WhichWorldToPlace
{
	BothWorlds = 0,
	RealWorld = 1,
	TVWorld = 2
}

public class PrefabTilemapToolWindow : EditorWindow
{
	private PrefabTilemapEditor m_PrefabTilemapEditor;

	private PrefabList m_PrefabListSO;
	private List<GameObject> m_PrefabList = new List<GameObject>();
	public GameObject m_ChosenPrefab;

	private Vector2 m_ScrollViewVector = Vector2.zero;
	public Rect m_DropDownRect = new Rect(110, 0, 125, 300);

	private int m_IndexNumber;
	private EditorCoroutine m_LastCoroutine;

	public WhichWorldToPlace m_WhichWorldToPlace;
	Vector2 scrollPos;

	private void Awake()
	{
		m_PrefabTilemapEditor = CreateInstance<PrefabTilemapEditor>();
		RefreshPrefabList();
	}

	[MenuItem("Tools/PrefabTileMap")]
	public static void ShowWindow()
	{ 
		GetWindow<PrefabTilemapToolWindow>("Prefab Tilemap");
	}

	void RefreshPrefabList()
	{
		m_PrefabListSO = Resources.Load("PrefabList") as PrefabList;

		m_PrefabList.Clear();

		for (int i = 0; i < m_PrefabListSO.ListOfPrefabs.Count; i++)
		{
			m_PrefabList.Add(m_PrefabListSO.ListOfPrefabs[i]);
		}
	}
	private void OnGUI()
	{
		EditorGUILayout.BeginHorizontal();

		scrollPos = EditorGUILayout.BeginScrollView(scrollPos, GUILayout.Width(400));
		m_WhichWorldToPlace = (WhichWorldToPlace)EditorGUILayout.EnumPopup("Place object in:", m_WhichWorldToPlace);
		EditorGUILayout.EndScrollView();

		EditorGUILayout.EndHorizontal();

		Vector3 point = new Vector3();
		Event currentEvent = Event.current;
		Vector2 mousePos = new Vector2();

		mousePos.x = currentEvent.mousePosition.x;
		mousePos.y = Camera.main.pixelHeight - currentEvent.mousePosition.y;

		point = Camera.main.ScreenToWorldPoint(new Vector3(mousePos.x, mousePos.y, Camera.main.nearClipPlane));
		/*
		GUILayout.BeginArea(new Rect(200, 20, 250, 120));
		GUILayout.Label("Screen pixels: " + Camera.main.pixelWidth + ":" + Camera.main.pixelHeight);
		GUILayout.Label("Mouse position: " + mousePos);
		GUILayout.Label("World position: " + point.ToString("F3"));
		GUILayout.EndArea();
		
		GUIStyle textStyle = new GUIStyle();
		textStyle.fontStyle = FontStyle.Bold;
		textStyle.fontSize = 16;
		GUI.Label(new Rect(20, 10, 100, 100), "Prefab Tilemap", textStyle);
		*/
		Rect btnRect = new Rect(m_DropDownRect.width - 88, 40, 100, 30);

		if (GUI.Button(btnRect, "Refresh List"))
		{
			RefreshPrefabList();
		}

		m_ScrollViewVector = GUI.BeginScrollView(new Rect((m_DropDownRect.x - 85), (m_DropDownRect.y + 85), m_DropDownRect.width + 10, m_DropDownRect.height + 100), m_ScrollViewVector, new Rect(0, 0, m_DropDownRect.width, m_PrefabList.Count));

		//GUI.Box(new Rect(0, 0, m_DropDownRect.width, Mathf.Max(m_DropDownRect.height + 1 * m_PrefabList.Count * 15, (m_PrefabList.Count))), "");


		for (int i = 0; i < m_PrefabList.Count; i++)
		{
			if (GUI.Button(new Rect(0, (i * 25), m_DropDownRect.width, 25), ""))
			{
				if (m_LastCoroutine != null)
				{
					EditorCoroutineUtility.StopCoroutine(m_LastCoroutine);
				}

				PrefabTilemapEditor.IsPlacing = false;
				m_ChosenPrefab = m_PrefabList[i];

				GameObject parent = null;

				switch (m_WhichWorldToPlace)
				{
					case WhichWorldToPlace.BothWorlds:
						parent = GameObject.Find("BothWorlds_Gameplay");
						break;
					case WhichWorldToPlace.RealWorld:
						parent = GameObject.Find("RealWorld_Gameplay");
						break;
					case WhichWorldToPlace.TVWorld:
						parent = GameObject.Find("TVWorld_Gameplay");
						break;
				}
				GameObject spawnedPrefab = PrefabUtility.InstantiatePrefab(m_PrefabList[i], parent.transform) as GameObject;
				spawnedPrefab.AddComponent<PlacePrefabTile>();
				spawnedPrefab.name = m_PrefabList[i].name;
				PrefabTilemapEditor.PrefabTile = spawnedPrefab;
				m_LastCoroutine = EditorCoroutineUtility.StartCoroutine(PrefabTilemapEditor.AllowPlacing(), this);
				Selection.activeGameObject = spawnedPrefab;
			}

			GUI.Label(new Rect(10, (i * 25), m_DropDownRect.height, 25), m_PrefabList[i].name);
		}

		GUI.EndScrollView();

	}
}
