import { NextFunction, Request, Response } from "express";
import jwt from 'jsonwebtoken'
import pkg from 'jsonwebtoken'

const { JsonWebTokenError } = pkg;

export const authMiddleware = (req:Request,res:Response, next:NextFunction)=>{
    try {
            
    const authHeader = req.headers.authorization
    if(!authHeader || !authHeader.startsWith('Bearer')){
        return res.status(401).json({
            "success": false,
            "data": null,
            "error": "UNAUTHORIZED"
        })
    }
    const token = authHeader.split(" ")[1]
    if(!token){
        return res.status(401).json({
            "success": false,
            "data": null,
            "error": "UNAUTHORIZED"
        })
    }

    jwt.verify(token,process.env.JWT_SECRET as string, (err,decoded)=>{
        if(err){
             return res.status(401).json({
                "success": false,
                "data": null,
                "error": "UNAUTHORIZED"
            })
        }
        (req as any).user = decoded
        next()
    })
    
    } catch (error) {
        console.log('Error in auth middleware\n',error)
        res.status(500).json({
            message:'Internal server error'
        })
    }
}