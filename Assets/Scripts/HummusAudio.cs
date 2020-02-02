using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HummusAudio : MonoBehaviour
{
	private AudioSource _audioSource;
	public AudioClip[] clips;
	public float cooldown = 90f;
	public int index;

	private void Start()
	{
		_audioSource = GetComponent<AudioSource>();
		cooldown = Random.Range(60f, 90f);
		index = Random.Range(0, clips.Length);
		StartCoroutine(PlayHummusCoroutine());
	}

	IEnumerator PlayHummusCoroutine()
	{
		while (true)
		{
			yield return new WaitForSeconds(cooldown);

			_audioSource.PlayOneShot(clips[index]);

			cooldown = Random.Range(60f, 90f);
			index = Random.Range(0, clips.Length);
		}
	}
}
