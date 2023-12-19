MODULE INTERFACE_ARRAY
  IMPLICIT NONE

  INTERFACE INTERFACE_FUNC
    MODULE PROCEDURE interface_funcb
  END INTERFACE

CONTAINS

  FUNCTION interface_funcb(arraya, arrayb) RESULT(res)
    REAL, DIMENSION(:) :: arraya
    REAL, DIMENSION(:) :: arrayb
    REAL, DIMENSION(SIZE(arrayb, 1)) :: res
    INTEGER :: i, randInt
    REAL :: randNum

    CALL RANDOM_SEED()

    DO i = 1, SIZE(arrayb, 1)
      CALL RANDOM_NUMBER(randNum)
      randInt = 2 + INT(3 * randNum)
      res(i) = (arraya(i) + randNum) * REAL(randInt)
    END DO
  END FUNCTION interface_funcb

END MODULE INTERFACE_ARRAY
