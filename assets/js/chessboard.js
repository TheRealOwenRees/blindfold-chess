import { Chess } from 'chess.js';

export const ChessBoard = {
    fenValue() {
        return this.el.dataset.fen;
    },
    sideValue() {
        return this.el.dataset.side;
    },
    mounted() {
        this.createBoard();
        this.createGame();
    },
    updated() {
        if (this.board) this.board.destroy();
        this.createBoard();
        this.createGame();
    },
    destroyed() {
        this.board.destroy();
    },
    createBoard() {
        try {
            const config = {
                orientation: this.sideValue(),
                position: this.fenValue(),
                showNotation: true
            }
            this.board = new Chessboard2('board1', config); \
        } catch (error) {
            console.log(error);
        }
    },
    createGame() {
        const chessGame = new Chess(this.fenValue());
        console.log(chessGame);
        console.log(chessGame.ascii())

        // TODO check move is valid in ChessJS lib
        // TODO convert move to UCI format
        this.handleEvent("validateMove", ({ move }) => {
            this.pushEvent("move_validated", {
                move: move,
                valid: true
            })
        })
    }

}