import express, { Request, Response } from 'express'
import { loginSchema, signupSchema } from '../schema/userSchema.js'
import { prisma } from '../lib/prisma.js'
import { ZodError } from 'zod'
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

const router = express.Router()

router.post('/signup',async(req:Request, res:Response)=>{
    try {
        const validatedData  = signupSchema.parse(req.body)
        const {name,email,password,role} = validatedData

        const userExists = await prisma.user.findFirst({
            where:{
                email:email
            }
        })
    if(userExists){
        return res.status(400).json({
            success:false,
            data:null,
            error: "EMAIL_ALREADY_EXISTS"

        })
    }

    const hashedPassword = await bcrypt.hash(password,8)

    const user = await prisma.user.create({
        data:{
            name,
            email,
            password:hashedPassword,
            role
        }
    })

    res.status(201).json({
        "success": true,
        "data": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role
        },
        "error": null
    })
    
    } catch (error) {
        if(error instanceof ZodError){
            console.log(error)
            return res.status(400).json({
                "success": false,
                "data": null, 
                "error": "INVALID_REQUEST"
            })
        }
        console.log("Error in signup route\n",error)
        res.status(500).json({
            message:'Internal server error'
        })
    }
    

})

router.post('/login',async(req:Request, res:Response)=>{
    
    try {
        const validatedData = loginSchema.parse(req.body)
        const {email, password} = validatedData
        
        const user = await prisma.user.findFirst({
            where:{
                email:email
            }
        })
        if(!user){
            return res.status(401).json({
                "success": false,
                "data": null,
                "error": "INVALID_CREDENTIALS"
            })
        }
        const comparePassword = await bcrypt.compare(password,user.password)

        if(!comparePassword){
            return res.status(401).json({
                "success": false,
                "data": null,
                "error": "INVALID_CREDENTIALS"
            })
        }
        
            const token = jwt.sign({
                id:user.id
            },process.env.JWT_SECRET as string)

            res.status(200).json({
                "success": true,
                "data": {
                    "token": token
                },
                "error": null
            })
        

    } catch (error) {
        if(error instanceof ZodError){
            console.log('Error in login user\n',error)
            return res.status(400).json({
                "success": false,
                "data": null,
                "error": "INVALID_REQUEST"
            })
        }
        console.log('Error in login user\n',error)
        res.status(500).json({
            message:'Internal server error'
        })

    }
})

export default router