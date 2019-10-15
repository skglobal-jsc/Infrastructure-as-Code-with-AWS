<template>
  <div class="main user-layout-register">
    <a-form id="formRegister" ref="formRegister" autocomplete="off" :form="form" @submit="handleSubmit">
      <a-tabs
        :active-key="customActiveKey"
        :tab-bar-style="{ textAlign: 'center', borderBottom: 'unset' }"
        @change="handleTabClick"
      >
        <a-tab-pane key="tab1" tab="SignUp with Email">
          <a-form-item>
            <a-input
              v-decorator="['email', {rules: [{ required: true, type: 'email', message: 'Please enter email address.' }], validateTrigger: ['change', 'blur']}]"
              size="large"
              type="text"
              placeholder="Emai"
            >
              <a-icon slot="prefix" type="mail" :style="{ color: 'rgba(0,0,0,.25)' }" />
            </a-input>
          </a-form-item>
        </a-tab-pane>
        <a-tab-pane key="tab2" disabled tab="SignUp with Phone">
          <a-form-item>
            <a-input v-decorator="['mobile', {rules: [{ required: true, message: 'Please enter a valid phone number', pattern: /^9[3456789]\d{7}$/ }, { validator: handlePhoneCheck } ], validateTrigger: ['change', 'blur'] }]" size="large" placeholder="Phone number, ex: 912345678">
              <a-select slot="addonBefore" v-model="countryCode" size="large" default-value="countryCode">
                <a-select-option value="+84">
                  +84
                </a-select-option>
              </a-select>
            </a-input>
          </a-form-item>
        </a-tab-pane>
      </a-tabs>

      <a-popover placement="rightTop" trigger="click" :visible="state.passwordLevelChecked">
        <template slot="content">
          <div :style="{ width: '240px' }">
            <div :class="['user-register', passwordLevelClass]">
              Password strength:
              <span>{{ passwordLevelName }}</span>
            </div>
            <a-progress
              :percent="state.percent"
              :show-info="false"
              :stroke-color=" passwordLevelColor "
            />
            <div style="margin-top: 10px;">
              <span>Please enter at least 8 characters. Please do not use passwords that are easy to guess.</span>
            </div>
          </div>
        </template>
        <a-form-item>
          <a-input
            v-decorator="['password', {rules: [{ required: true, message: 'At least 8-digit password, case sensitive.'}, { validator: handlePasswordLevel }], validateTrigger: ['change', 'blur']}]"
            size="large"
            type="password"
            autocomplete="new-password"
            placeholder="Password"
            @click="handlePasswordInputClick"
          />
        </a-form-item>
      </a-popover>

      <a-form-item>
        <a-input
          v-decorator="['password2', {rules: [{ required: true, message: 'At least 8-digit password, case sensitive.' }, { validator: handlePasswordCheck }], validateTrigger: ['change', 'blur']}]"
          size="large"
          type="password"
          autocomplete="false"
          placeholder="Confirm password"
        />
      </a-form-item>

      <a-form-item>
        <a-button
          size="large"
          type="primary"
          html-type="submit"
          class="register-button"
          :loading="registerBtn"
          :disabled="registerBtn"
        >
          Create account
        </a-button>
        <a class="login" @click="signIn">Sign In</a>
      </a-form-item>
    </a-form>
  </div>
</template>

<script>
import Auth from '@aws-amplify/auth'

const levelNames = {
  0: 'Very weak',
  1: 'Weak',
  2: 'Good',
  3: 'Great'
}
const levelClass = {
  0: 'error',
  1: 'error',
  2: 'warning',
  3: 'success'
}
const levelColor = {
  0: '#ff0000',
  1: '#ff0000',
  2: '#ff7e05',
  3: '#52c41a'
}
// TODO phone reg
// ^\+?[1-9]\d{1,14}$
export default {
  name: 'SignUp',
  props: {
    signUpConfig: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      form: this.$form.createForm(this),
      customActiveKey: 'tab1',
      countryCode: '+84',
      state: {
        passwordLevel: 0,
        passwordLevelChecked: false,
        percent: 10,
        progressColor: '#FF0000'
      },
      registerBtn: false
    }
  },
  computed: {
    options() {
      const defaults = {}
      return Object.assign(defaults, this.signUpConfig || {})
    },
    passwordLevelClass() {
      return levelClass[this.state.passwordLevel]
    },
    passwordLevelName() {
      return levelNames[this.state.passwordLevel]
    },
    passwordLevelColor() {
      return levelColor[this.state.passwordLevel]
    }
  },
  watch: {
    'state.passwordLevel'(val) {
      console.log(val)
    }
  },
  methods: {
    handleTabClick(key) {
      this.customActiveKey = key
      // this.form.resetFields()
    },
    handlePasswordLevel(rule, value, callback) {
      let level = 0

      // Determine if there are any numbers in this string
      if (/[0-9]/.test(value)) {
        level++
      }
      // Determine if there are any letters in the string
      if (/[a-zA-Z]/.test(value)) {
        level++
      }
      // Determine if there are any special symbols in the string
      if (/[^0-9a-zA-Z_]/.test(value)) {
        level++
      }
      this.state.passwordLevel = level
      this.state.percent = level * 30
      if (level >= 2) {
        if (level >= 3) {
          this.state.percent = 100
        }
        callback()
      } else {
        if (level === 0) {
          this.state.percent = 10
        }
        callback(new Error('Insufficient password strength'))
      }
    },
    handlePhoneCheck(rule, value, callback) {
      callback()
    },
    handlePasswordCheck(rule, value, callback) {
      const password = this.form.getFieldValue('password')
      // console.log('value', value)
      if (value === undefined) {
        callback(new Error('Please enter your password'))
      }
      if (value && password && value.trim() !== password.trim()) {
        callback(new Error('Two passwords are inconsistent'))
      }
      callback()
    },

    handlePasswordInputClick() {
      // if (!this.isMobile()) {
      //   this.state.passwordLevelChecked = true
      //   return
      // }
      this.state.passwordLevelChecked = true
    },

    handleSubmit(e) {
      e.preventDefault()
      const {
        form: { validateFields },
        customActiveKey
      } = this
      const validateFieldsKey = customActiveKey === 'tab1' ? ['email', 'password'] : ['mobile', 'password']
      validateFields(validateFieldsKey, { force: true }, (err, values) => {
        if (!err) {
          let user = {
            attributes: {
              phone_number: `${this.countryCode}${values.mobile}`
            },
            username: `${this.countryCode}${values.mobile}`,
            password: values.password
          }
          if (customActiveKey === 'tab1') {
            user = {
              attributes: {
                // phone_number: `+${this.countryCode}${e.value}`
                email: values.email
              },
              username: values.email,
              password: values.password
            }
          }
          Auth.signUp(user)
            .then((data) => {
              this.$bus.$emit('localUser', data.user)
              if (data.userConfirmed === false) {
                return this.$bus.$emit('authState', 'confirmSignUp')
              }
              return this.$bus.$emit('authState', 'signIn')
            })
            .catch(e => this.setError(e))
        }
      })
    },

    setError(err) {
      this.$notification.error({
        message: 'Error',
        description: err.message || 'Request error, please try again later',
        duration: 4
      })
      this.registerBtn = false
    },
    signIn() {
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

.user-layout-register {
  .ant-input-group-addon:first-child {
    background-color: #fff;
  }
}
</style>
<style lang="scss" scoped>
.user-layout-register {
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
