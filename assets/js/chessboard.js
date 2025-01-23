export const ChessBoard = {
    fenValue() {
        return this.el.dataset.fen;
    },
    sideValue() {
        return this.el.dataset.side;
    },
    mounted() {
        try {
            const fen = this.fenValue()
            const side = this.sideValue()
            const config = {
                orientation: side,
                position: fen,
            }
            this.board = new Chessboard2('board1', config);
        } catch (error) {
            console.log(error);
        }
    },
    destroyed() {
        this.board.destroy();
    }

}