PROGRAM MainProgram
  USE INITIALISE
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: ARRAY_AI
  REAL, DIMENSION(:,:), ALLOCATABLE :: ARRAY_TYPE
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: RESULT_ARRAY
  INTEGER :: i, j, k, run

  INTEGER, PARAMETER :: dim1 = 500, dim2 = 500, dim3 = 500, total_runs = 10

  ALLOCATE(ARRAY_AI(dim1, dim2, dim3))
  ALLOCATE(ARRAY_TYPE(dim2, dim3))

  CALL RANDOM_SEED()

  DO i = 1, dim1
    DO j = 1, dim2
      DO k = 1, dim3
        IF (i == 1) THEN
          CALL RANDOM_NUMBER(ARRAY_AI(i, j, k))
          CALL RANDOM_NUMBER(ARRAY_TYPE(j, k))
        ELSE 
          CALL RANDOM_NUMBER(ARRAY_AI(i, j, k))
        END IF
      END DO
    END DO
  END DO

  DO run = 1, total_runs
    RESULT_ARRAY = init(ARRAY_AI, ARRAY_TYPE)
  END DO

  DEALLOCATE(ARRAY_AI, ARRAY_TYPE, RESULT_ARRAY)

END PROGRAM MainProgram
