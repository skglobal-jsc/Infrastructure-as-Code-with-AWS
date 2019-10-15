<template>
  <div class="main user-layout-confirm">
    <h3>Confirm Sign Up</h3>
    <a-form id="formConfirm" ref="formConfirm" :form="form">
      <a-form-item>
        <a-input
          v-decorator="['username', {initialValue: options.username, rules: [{ required: true, message: 'Please input username' }], validateTrigger: ['change', 'blur']}]"
          size="large"
          type="text"
          autocomplete="new-username"
          placeholder="Username"
        />
      </a-form-item>
      <a-row :gutter="16">
        <a-col class="gutter-row" :span="16">
          <a-form-item>
            <a-input
              v-decorator="['code', {rules: [{ required: true, message: 'Please input verification code' }], validateTrigger: 'blur'}]"
              size="large"
              type="text"
              placeholder="Verification code"
            >
              <a-icon slot="prefix" type="mail" :style="{ color: 'rgba(0,0,0,.25)' }" />
            </a-input>
          </a-form-item>
        </a-col>
        <a-col class="gutter-row" :span="8">
          <a-button
            class="getCaptcha"
            size="large"
            :disabled="state.smsSendBtn"
            @click.stop.prevent="resend"
            v-text="!state.smsSendBtn && 'Resend'||(state.time+' s')"
          />
        </a-col>
      </a-row>

      <a-form-item>
        <a class="login" @click="signIn">Back to Sign In</a>
        <a-button
          size="large"
          type="primary"
          html-type="submit"
          class="register-button"
          :loading="confirmBtn"
          :disabled="confirmBtn"
          @click.stop.prevent="handleSubmit"
        >
          Confirm
        </a-button>
      </a-form-item>
    </a-form>
  </div>
</template>

<script>
import Auth from '@aws-amplify/auth'
export default {
  name: 'ConfirmSignUp',
  props: {
    confirmSignUpConfig: {
      type: Object,
      default: () => {}
    }
  },
  data () {
    return {
      form: this.$form.createForm(this),
      state: {
        time: 60,
        smsSendBtn: false
      },
      confirmBtn: false
    }
  },
  computed: {
    options () {
      const defaults = {
        username: ''
      }
      return Object.assign(defaults, this.confirmSignUpConfig || {})
    }
  },
  methods: {
    handleSubmit () {
      const {
        form: { validateFields }
      } = this
      validateFields({ force: true }, (err, values) => {
        if (!err) {
          const { username, code } = values
          this.confirm(username, code)
        }
      })
    },
    confirm (username, code) {
      this.confirmBtn = true
      Auth.confirmSignUp(username, code)
        .then(() => {
          this.$bus.$emit('authState', 'signIn')
        })
        .catch(e => this.setError(e))
        .finally(() => {
          this.confirmBtn = false
        })
    },
    resend (e) {
      e.preventDefault()
      const {
        form: { validateFields },
        state,
        $message,
        $notification
      } = this

      validateFields(['username'], { force: true }, (err, values) => {
        if (!err) {
          state.smsSendBtn = true

          const interval = window.setInterval(() => {
            if (state.time-- <= 0) {
              state.time = 60
              state.smsSendBtn = false
              window.clearInterval(interval)
            }
          }, 1000)

          const hide = $message.loading('Verification code is being sent..', 0)
          Auth.resendSignUp(values.username)
            .then(() => {
              $notification.success({
                message: 'Info',
                description: 'The verification code is successfully obtained. Please check your e-mail',
                duration: 8
              })
            })
            .catch((err) => {
              clearInterval(interval)
              state.time = 60
              state.smsSendBtn = false
              this.setError(err)
            })
            .finally(() => {
              setTimeout(hide, 1)
            })
        }
      })
    },
    setError (err) {
      this.$notification.error({
        message: 'Error',
        description: err.message || 'Request error, please try again later',
        duration: 4
      })
      this.confirmBtn = false
    },
    signIn () {
      this.$bus.$emit('authState', 'signIn')
    }
  }
}
</script>
<style lang="scss">
.user-register {
  &.error {
    color: #ff0000;
  }

  &.warning {
    color: #ff7e05;
  }

  &.success {
    color: #52c41a;
  }
}

.user-layout-confirm {
  .ant-input-group-addon:first-child {
    background-color: #fff;
  }
}
</style>
<style lang="scss" scoped>
.user-layout-confirm {
  & > h3 {
    font-size: 16px;
    margin-bottom: 20px;
  }

  .getCaptcha {
    display: block;
    width: 100%;
    height: 40px;
  }

  .register-button {
    width: 50%;
  }

  .login {
    float: right;
    line-height: 40px;
  }
}
</style>
