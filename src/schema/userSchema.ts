import {email, z} from 'zod'

export const signupSchema = z.object({
    name:z.string(),
    email:z.email(),
    password:z.string(),
    role:z.enum(['creator','contestee']).default('contestee')
})
.strict()

export const loginSchema = z.object({
    email:z.email(),
    password:z.string()
})
.strict()