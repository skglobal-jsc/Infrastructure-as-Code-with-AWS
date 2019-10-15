<template>
  <a-spin :spinning="uploading">
    <a-upload
      name="avatar"
      accept=".png, .jpg, .jpeg"
      :show-upload-list="false"
      :custom-request="uploadS3"
      :before-upload="beforeUpload"
      @change="handleChange"
    >
      <div class="ant-upload-preview">
        <div class="mask">
          <a-icon type="camera" />
        </div>
        <a-avatar class="avatar" :size="120" :src="tempUrl" icon="user" />
      </div>
    </a-upload>
  </a-spin>
</template>
<script>
import Storage from '@aws-amplify/storage'

export default {
  props: {
    avatar: { type: String, required: true, default: '' }
  },
  data () {
    return {
      uploading: false,
      tempUrl: ''
    }
  },
  created () {
    this.getS3Image()
  },
  methods: {
    beforeUpload (file) {
      const isLt2M = file.size / 1024 / 1024 < 2
      if (!isLt2M) {
        this.$message.error('Image size must smaller than 2MB!')
      }
      return isLt2M
    },

    getS3Image () {
      const key = 'avatar'
      const level = 'protected'
      Storage.get(key, { level })
        .then((url) => { this.tempUrl = url })
        .catch(err => this.$message.error('Cannot get user avatar'))
    },

    handleChange (info) {
      if (info.file.status === 'done') {
        this.getS3Image()
      }
      this.uploading = info.file.status === 'uploading'
    },

    uploadS3 ({ data, file, onError, onProgress, onSuccess }) {
      const key = 'avatar'
      const level = 'protected'

      Storage.put(key, file, {
        level,
        contentType: file.type,
        cacheControl: '31536000', // 1 year
        progressCallback: ({ total, loaded }) => {
          onProgress({ percent: Math.round((loaded / total) * 100) }, file)
        }
      })
        .then(({ key }) => ({ key, level }))
        .then((response) => { onSuccess(response, file) })
        .catch(onError)
    }
  }
}
</script>
<style lang="scss" scoped>
.ant-upload-preview {
  position: relative;
  margin: 0 auto;
  width: 100%;
  max-width: 120px;
  border-radius: 50%;
  box-shadow: 0 0 4px #ccc;
  .mask {
    opacity: 0;
    position: absolute;
    cursor: pointer;
    transition: opacity 0.4s;
    background: rgba(0, 0, 0, 0.4);
    z-index: 10;
    &:hover {
      opacity: 1;
    }
    i {
      font-size: 2rem;
      position: absolute;
      top: 50%;
      left: 50%;
      margin-left: -1rem;
      margin-top: -1rem;
      color: #d6d6d6;
    }
  }
  .avatar,
  .mask {
    width: 100%;
    max-width: 180px;
    height: 100%;
    border-radius: 50%;
    overflow: hidden;
  }
}
</style>
