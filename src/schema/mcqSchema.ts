import {z} from 'zod'

export const mcqSchema = z.object({
    questionText : z.string(),
    options:z.array(z.string()).length(4),
    correctOptionIndex: z.number().min(1).max(4),
    points:z.number()
})
.strict()