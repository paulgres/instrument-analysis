program idxstats
    
    !use instrument_analysis, only: say_hello
    use modio
    use modstats
    use modmem
  implicit none

  character(len=:), allocatable :: date(:), names(:),n(:)
    character(len=64) :: arg
    real, allocatable :: idx(:,:), r(:,:)
    real ::e, start, stop, k(2)
    integer::i,stat
    character(100)::errmsg
    logical::csv, lexists
    csv = .False.

  if (COMMAND_ARGUMENT_COUNT() .eq. 0) then
    print *, "Nothing to do..."
    call exit()
  end if
  call get_command_argument(1,arg)
  

  do i = 1, command_argument_count()
    call get_command_argument(i, arg)

    if (arg .eq. '-c') then 
        csv=.True.
        goto 100
    end if
    
    inquire(file=trim(arg)//'.txt', exist=lexists)
    if (.not. lexists) then 
      inquire(file=trim(arg)//'.csv', exist=lexists)
        if (.not. lexists) then
          print *, "Input file for ", trim(arg), " not found.. skipping"
          goto 100
        end if 
        call read_idx(trim(arg)//'.csv', date, names, idx, csv=.TRUE., stat=stat, errmsg=errmsg)
        call write_fwf(trim(arg)//'.txt', date, names, idx)
    else
        call read_idx(trim(arg)//'.txt', date, names, idx, stat=stat, errmsg=errmsg)
        call write_fwf(trim(arg)//'2.txt', date, names, idx)  !this was to test the output file 
    end if
    if (stat .ne. 0)then
      print *, errmsg, " ..skipping"
      goto 100
    end if
    
    print *, 'Processing ', trim(arg)
    call cpu_time(start)

    r = idx_stats(idx)

    call cpu_time(stop)
    print *, 'elapsed:', stop-start
    call freem(idx)
    if (allocated(names))deallocate(names)
    n = ['R50 ','R100','R200']
    call write_fwf(trim(arg)//'_res.txt', date, n, r)
    
100     continue        
  end do

end program idxstats