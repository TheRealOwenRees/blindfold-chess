export const ChessBoard = {
    fenValue() {
        return this.el.dataset.fen;
    },
    sideValue() {
        return this.el.dataset.side;
    },
    mounted() {
        this.create();
    },
    updated() {
        if (this.board) this.board.destroy()

        this.create()
    },
    destroyed() {
        this.board.destroy();
    },
    create() {
        try {
            const config = {
                orientation: this.sideValue(),
                position: this.fenValue(),
                showNotation: true
            }
            this.board = new Chessboard2('board1', config);
        } catch (error) {
            console.log(error);
        }
    }

}