/* Automatically generated by adlc */

import * as sys_types from './types';

export type ModuleName = string;

export type Ident = string;

export type Annotations = sys_types.Map<ScopedName, Literal>;

export interface ScopedName {
  moduleName: ModuleName;
  name: Ident;
}

export function makeScopedName(
  input: {
    moduleName: ModuleName,
    name: Ident,
  }
): ScopedName {
  return {
    moduleName: input.moduleName,
    name: input.name,
  };
}

export interface Literal_Null {
  kind: 'null';
}
export interface Literal_Integer {
  kind: 'integer';
  value: number;
}
export interface Literal_Double {
  kind: 'double';
  value: number;
}
export interface Literal_String {
  kind: 'string';
  value: string;
}
export interface Literal_Boolean {
  kind: 'boolean';
  value: boolean;
}
export interface Literal_Array {
  kind: 'array';
  value: Literal[];
}
export interface Literal_Object {
  kind: 'object';
  value: sys_types.Map<string, Literal>;
}

export type Literal = Literal_Null | Literal_Integer | Literal_Double | Literal_String | Literal_Boolean | Literal_Array | Literal_Object;

export interface TypeRef_Primitive {
  kind: 'primitive';
  value: Ident;
}
export interface TypeRef_TypeParam {
  kind: 'typeParam';
  value: Ident;
}
export interface TypeRef_Reference {
  kind: 'reference';
  value: ScopedName;
}

export type TypeRef = TypeRef_Primitive | TypeRef_TypeParam | TypeRef_Reference;

export interface TypeExpr {
  typeRef: TypeRef;
  parameters: TypeExpr[];
}

export function makeTypeExpr(
  input: {
    typeRef: TypeRef,
    parameters: TypeExpr[],
  }
): TypeExpr {
  return {
    typeRef: input.typeRef,
    parameters: input.parameters,
  };
}

export interface Field {
  name: Ident;
  serializedName: Ident;
  typeExpr: TypeExpr;
  default: sys_types.Maybe<Literal>;
  annotations: Annotations;
}

export function makeField(
  input: {
    name: Ident,
    serializedName: Ident,
    typeExpr: TypeExpr,
    default: sys_types.Maybe<Literal>,
    annotations: Annotations,
  }
): Field {
  return {
    name: input.name,
    serializedName: input.serializedName,
    typeExpr: input.typeExpr,
    default: input.default,
    annotations: input.annotations,
  };
}

export interface Struct {
  typeParams: Ident[];
  fields: Field[];
}

export function makeStruct(
  input: {
    typeParams: Ident[],
    fields: Field[],
  }
): Struct {
  return {
    typeParams: input.typeParams,
    fields: input.fields,
  };
}

export interface Union {
  typeParams: Ident[];
  fields: Field[];
}

export function makeUnion(
  input: {
    typeParams: Ident[],
    fields: Field[],
  }
): Union {
  return {
    typeParams: input.typeParams,
    fields: input.fields,
  };
}

export interface TypeDef {
  typeParams: Ident[];
  typeExpr: TypeExpr;
}

export function makeTypeDef(
  input: {
    typeParams: Ident[],
    typeExpr: TypeExpr,
  }
): TypeDef {
  return {
    typeParams: input.typeParams,
    typeExpr: input.typeExpr,
  };
}

export interface NewType {
  typeParams: Ident[];
  typeExpr: TypeExpr;
  default: sys_types.Maybe<Literal>;
}

export function makeNewType(
  input: {
    typeParams: Ident[],
    typeExpr: TypeExpr,
    default: sys_types.Maybe<Literal>,
  }
): NewType {
  return {
    typeParams: input.typeParams,
    typeExpr: input.typeExpr,
    default: input.default,
  };
}

export interface DeclType_Struct_ {
  kind: 'struct_';
  value: Struct;
}
export interface DeclType_Union_ {
  kind: 'union_';
  value: Union;
}
export interface DeclType_Type_ {
  kind: 'type_';
  value: TypeDef;
}
export interface DeclType_Newtype_ {
  kind: 'newtype_';
  value: NewType;
}

export type DeclType = DeclType_Struct_ | DeclType_Union_ | DeclType_Type_ | DeclType_Newtype_;

export interface Decl {
  name: Ident;
  version: sys_types.Maybe<number>;
  type_: DeclType;
  annotations: Annotations;
}

export function makeDecl(
  input: {
    name: Ident,
    version: sys_types.Maybe<number>,
    type_: DeclType,
    annotations: Annotations,
  }
): Decl {
  return {
    name: input.name,
    version: input.version,
    type_: input.type_,
    annotations: input.annotations,
  };
}

export interface ScopedDecl {
  moduleName: ModuleName;
  decl: Decl;
}

export function makeScopedDecl(
  input: {
    moduleName: ModuleName,
    decl: Decl,
  }
): ScopedDecl {
  return {
    moduleName: input.moduleName,
    decl: input.decl,
  };
}

export type DeclVersions = Decl[];

export interface Import_ModuleName {
  kind: 'moduleName';
  value: ModuleName;
}
export interface Import_ScopedName {
  kind: 'scopedName';
  value: ScopedName;
}

export type Import = Import_ModuleName | Import_ScopedName;

export interface Module {
  name: ModuleName;
  imports: Import[];
  decls: sys_types.Map<Ident, Decl>;
  annotations: Annotations;
}

export function makeModule(
  input: {
    name: ModuleName,
    imports: Import[],
    decls: sys_types.Map<Ident, Decl>,
    annotations: Annotations,
  }
): Module {
  return {
    name: input.name,
    imports: input.imports,
    decls: input.decls,
    annotations: input.annotations,
  };
}