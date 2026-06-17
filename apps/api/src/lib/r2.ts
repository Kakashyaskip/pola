export function photoKey(eventId: string, photoId: string): string {
  return `events/${eventId}/${photoId}.jpg`
}

export async function createSignedUploadUrl(
  bucket: R2Bucket,
  key: string,
  expiresInSeconds = 300,
): Promise<string> {
  const url = await (bucket as R2Bucket & {
    createMultipartUpload: unknown
    createPresignedUrl: (
      method: string,
      key: string,
      options: { expiresIn: number },
    ) => Promise<string>
  }).createPresignedUrl('PUT', key, { expiresIn: expiresInSeconds })
  return url
}

export async function createSignedDownloadUrl(
  bucket: R2Bucket,
  key: string,
  expiresInSeconds = 3600,
): Promise<string> {
  const url = await (bucket as R2Bucket & {
    createPresignedUrl: (
      method: string,
      key: string,
      options: { expiresIn: number },
    ) => Promise<string>
  }).createPresignedUrl('GET', key, { expiresIn: expiresInSeconds })
  return url
}
