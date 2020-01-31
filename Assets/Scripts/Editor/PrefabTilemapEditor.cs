using UnityEngine;
using UnityEditor;
using System.Collections;
using Unity.EditorCoroutines.Editor;

[CustomEditor(typeof(PlacePrefabTile))]
public class PrefabTilemapEditor : Editor
{
	public static Vector2 mousePos = new Vector2();
	public static GameObject PrefabTile;
	public static bool IsPlacing = false;

	void OnSceneGUI()
	{
		if (PrefabTile == null) return;

		Vector3 point = new Vector3();
		Event currentEvent = Event.current;

		mousePos.x = currentEvent.mousePosition.x;
		mousePos.y = SceneView.lastActiveSceneView.camera.pixelHeight - currentEvent.mousePosition.y;

		point = SceneView.lastActiveSceneView.camera.ScreenToWorldPoint(new Vector3(mousePos.x, mousePos.y, Camera.main.nearClipPlane));
	
		PrefabTile.transform.position = new Vector3(point.x, point.y, 0);

		if (currentEvent.button == 0 && currentEvent.isMouse && IsPlacing && currentEvent.type == EventType.MouseDown)
		{
			DestroyImmediate(PrefabTile.GetComponent<PlacePrefabTile>());
			
			point = new Vector3(Mathf.RoundToInt(point.x), Mathf.RoundToInt(point.y), 0);
			PrefabTile.transform.position = point;
			PrefabTile = null;
			IsPlacing = false;
		}
	}

	public static IEnumerator AllowPlacing()
	{
		IsPlacing = false;

		yield return new WaitForSecondsRealtime(1);

		IsPlacing = true;
	}
}
