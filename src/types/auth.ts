export interface LoginPayload {
  email: string
  password: string
}

export interface RegisterPayload {
  business_name: string
  business_code: string
  owner_name: string
  email: string
  password: string
  password_confirmation: string
}

export interface AuthUser {
  token: string
  name: string
  role: string
  business: string | null
  outlet: string | null
}
