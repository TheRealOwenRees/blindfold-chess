export const ChessBoard = {
    value() {
        return this.el.dataset.fen;
    },
    mounted() {
        try {
            const fen = this.value()
            this.board = new Chessboard2('board1', fen);
        } catch (error) {
            console.log(error);
        }
    },
    destroyed() {
        this.board.destroy();
    }

}