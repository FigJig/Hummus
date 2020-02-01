using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
	public Vector3 cameraOffsetFromPlayer;
	public bool smoothFollow;
	public float smoothFollowSpeed;

	private Transform _player;

    void Start()
    {
		_player = PlayerDataModule.Inst.transform;
    }

    void LateUpdate()
    {
		Vector3 playerPos = new Vector3(_player.position.x + cameraOffsetFromPlayer.x, _player.position.y + cameraOffsetFromPlayer.y, _player.position.z + cameraOffsetFromPlayer.z);
		Vector3 targetPos;

		if (smoothFollow)
		{
			targetPos = Vector3.Lerp(transform.position, playerPos, smoothFollowSpeed * Time.deltaTime);
		}
		else
		{
			targetPos = playerPos;
		}

		transform.position = targetPos;
    }
}
