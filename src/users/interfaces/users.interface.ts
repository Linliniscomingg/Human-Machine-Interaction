export interface Iuser {
    username:string,
    password:string,
    role:"doctor"|"patient",
    userProfile: IProfile,
    mskProblem:string[],
}

export interface IProfile {
    firstName?:string,
    lastName?:string,
    phoneNumber?:string,
    weight?:number,
    height?:number,
    dateOfBirth?:Date,
    gender?:"male"|"female",
    address?:string,
    avatar?:string
}