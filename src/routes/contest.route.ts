import express, { Request, Response } from 'express'
import { prisma } from '../lib/prisma.js'
import { createContestSchema } from '../schema/contestSchema.js'
import { ZodError } from 'zod'
const router = express.Router()

router.post('/',async(req:Request, res:Response)=>{
    try {
        
    const userId = (req as any).user.id
    const user = await prisma.user.findFirst({
        where:{
            id:userId
        }
    })
    if(user?.role != 'creator'){
        return res.status(403).json({
            "success": false,
            "data": null,
            "error": "FORBIDDEN"
        })
    }


    const validatedData = createContestSchema.parse(req.body)
    const {title,description,startTime,endTime} = validatedData

    const contest = await prisma.contest.create({
        data:{
            title,
            description,
            start_time:startTime,
            end_time:endTime,
            creator_id:user.id 
        }
    })

    res.status(201).json({
        "success": true,
        "data": {
            "id": contest.id,
            "title": contest.title,
            "description": contest.description,
            "creatorId": contest.creator_id,
            "startTime": contest.start_time,
            "endTime": contest.end_time
        },
        "error": null
    })

    
    } catch (error) {
     if(error instanceof ZodError){
        console.error('Zod Error in creating contest route\n',error)
        res.status(400).json({
            "success": false,
            "data": null,
            "error": "INVALID_REQUEST"
        })
     }   
     console.error('Error in creating contest\n',error)
     res.status(500).json({
        message:'Internal server error'
     })
    }
    
})

export default router