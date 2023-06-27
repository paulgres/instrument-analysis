    module modstats
    use, intrinsic:: ieee_arithmetic
    use modmem
    implicit none
    

    
    private
    public::idx_stats
    
    contains
    
    
    pure function rolling(m, w) result(r)
        real, intent(in)::m(:,:)
        integer, intent(in)::w
        real, allocatable::r(:,:)
        integer::sm(2),i
        sm=shape(m)
        allocate(r, mold=m)
        do concurrent (i=1:sm(2))
            r(:,i)=moving_average(m(:,i),w)
        end do
    end function rolling
    
    pure real function average(x)
        ! Returns a average of x.
        real, intent(in) :: x(:)
        average = sum(x) / size(x)
    end function average
    
    pure function moving_average(x, w) result(res)
    ! Returns the moving average of x with one-sided window w.
        real, intent(in) :: x(:)
        real::t(size(x))
        integer, intent(in) :: w
        real :: res(size(x))
        integer :: i, k1,k
        k=1
        do i = 1, size(x)
            if (.not. ieee_is_nan(x(i)))then
                t(k)=x(i)
                k=k+1
            end if
            if (k .le. w) then 
                res(i)=ieee_value(res(i),IEEE_QUIET_NAN)
            else
                k1 = max(k-w, 1)
                res(i) = average(t(k1:k-1))
            end if 
        end do 
    end function moving_average
      
    pure function count_nnans(matrix)result(nans)
        real, allocatable, intent(in)::matrix(:,:)
        real, allocatable::nans(:)
        integer:: i,j,n,sm(2)
        sm=shape(matrix)
        allocate(nans(sm(1)))
    
        do concurrent (i=1:sm(1))
            nans(i)=sm(2)
            do j =1,sm(2)
            if (ieee_is_nan(matrix(i,j))) then
                nans(i)=nans(i)-1
            end if
        
            end do
        
        end do
    end function
    
    pure function idx_stats(matrix)result(res)
        real, allocatable :: res(:,:)
        real, intent(in)::matrix(:,:)
        real, allocatable ::smavg50(:,:),smavg100(:,:),smavg200(:,:)
        logical, allocatable :: cmp50(:,:),cmp100(:,:),cmp200(:,:)
        integer::sm(2)
        
        sm=shape(matrix)
        allocate(res(sm(1),3))
        
        smavg50 = rolling(matrix, 50)
        smavg100 = rolling(matrix, 100)
        smavg200 = rolling(matrix, 200)
        
        cmp50 = transpose(smavg50) <= transpose(matrix)
        cmp100 = transpose(smavg100) <= transpose(matrix)
        cmp200 = transpose(smavg200) <= transpose(matrix)
        
        res(:,1) = count(cmp50, 1) /count_nnans(smavg50)
        res(:,2) = count(cmp100, 1) /count_nnans(smavg100)
        res(:,3) = count(cmp200, 1) /count_nnans(smavg200)
    
    end function idx_stats
    
    end module modstats