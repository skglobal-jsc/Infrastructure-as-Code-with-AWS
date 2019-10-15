import Storage from '@aws-amplify/storage'

export default {
  getImage (key, options) {
    return new Promise((resolve, reject) => {
      Storage.get(key, options)
        .then((rs) => {
          resolve(rs)
        })
        .catch(() => {
          reject(new Error('Image path is invalid'))
        })
    })
  },
  get ({ key, level, userId }) {
    return new Promise((resolve, reject) => {
      Storage.get(key, {
        level,
        identityId: userId
      })
        .then((rs) => {
          resolve(rs)
        })
        .catch(() => reject(new Error('Cannot download file')))
    })
  },
  upload (key, file, config) {
    return new Promise((resolve, reject) => {
      Storage.put(key, file, config)
        .then((res) => resolve(res))
        .catch(err => reject(err))
    })
  }
}
