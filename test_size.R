require(sfsmisc)

setwd('~/compwork/postgres/spherical')

o_pg = scan('out_size_pg', list(t=0, n=0, sr=0, hbread=0, hbhit=0, ibread=0, ibhit=0))

png('fig_size_number_time.png', width=1024, height=768)
plot(o_pg$n, o_pg$t, type="b", pch=2, col="red", log='xy', cex=0.5, xlim=c(1e4,1e8), ylim=c(1e-2,1e2),
     xlab="Number of points in table", ylab="Query time, ms", axes=FALSE)
box()
eaxis(1)
eaxis(2)
dev.off()

## #png('fig_match_number_time.png', width=1024, height=768)
## plot(o_pg$n, (o_pg$ibread + o_pg$hbread), type="b", pch=2, col="red", log='xy', cex=0.5, xlim=c(1e4,1e8), ylim=c(1,1e5),
##      xlab="Number of points in table", ylab="idx_blks_read", axes=FALSE)
## box()
## eaxis(1)
## eaxis(2)
## #dev.off()
