export const successResponse = (data:any)=>{
    return {
        "success":true,
        data:data,
        "error":null
    }
}

export const errorResponse = (error:String)=>{
    return{
        "success":false,
        "data":null,
        error
    }
}