import {z} from 'zod'

export const mcqSchema = z.object({
    questionText : z.string(),
    options:z.array(z.string()).length(4),
    correctOptionIndex: z.number().min(0).max(4),
    points:z.number()
})
.strict()

export const selectedOptionSchema = z.object({
    selectedOptionIndex : z.number().nonnegative().max(3)
})
.strict()