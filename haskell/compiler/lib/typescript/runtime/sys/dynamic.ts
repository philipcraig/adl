/* Automatically generated by adlc */

import * as sys_adlast from './adlast';

/**
 * A serialised value along with  its type
 */
export interface Dynamic {
  typeExpr: sys_adlast.TypeExpr;
  value: {};
}

export function makeDynamic(
  input: {
    typeExpr: sys_adlast.TypeExpr,
    value: {},
  }
): Dynamic {
  return {
    typeExpr: input.typeExpr,
    value: input.value,
  };
}
