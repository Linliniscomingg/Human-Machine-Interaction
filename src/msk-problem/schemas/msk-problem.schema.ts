
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { ValidateNested } from 'class-validator';
import { HydratedDocument } from 'mongoose';

export type MskProblemDocument = HydratedDocument<MskProblem>;

@Schema(
    {
        timestamps: true,
        toJSON: {
            virtuals: true,
            transform: (_, ret) => {
                delete ret.id;
                delete ret._id;
                delete ret.__v;
                return ret;
            }
        }
    }
)
export class MskProblem {
    @Prop({ required: true })
    bodyPart: string

    @Prop()
    injury: string

    @Prop()
    levelOfPain: string


    @Prop()
    doctorNotes: string

    @Prop({
        type: Object,
        default: {}
    })
    @ValidateNested()
    prescription: Object
}

export const MskProblemSchema = SchemaFactory.createForClass(MskProblem);
